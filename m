From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] splice: sendfile() at once fails for big files
Date: Tue, 5 May 2015 20:41:05 -0700
Message-ID: <CA+55aFyc+A25ozSTVNNHmBL_kUhv9u5kUq9esxjYggmqfPRE9w@mail.gmail.com>
References: <20150423150308.8782B1A2439@localhost.localdomain>
	<20150427070131.GA21190@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Christophe Leroy <christophe.leroy@c-s.fr>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Jens Axboe <axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150427070131.GA21190@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Jens, ping?

The test results should make this a no-brainer, but I hate how random
these flag ops.

                      Linus


On Mon, Apr 27, 2015 at 12:01 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> Christophe Leroy <christophe.leroy@c-s.fr> wrote:
>> Using sendfile with below small program to get MD5 sums of some files,
>> it appear that big files (over 64kbytes with 4k pages system) get a
>> wrong MD5 sum while small files get the correct sum.
>> This program uses sendfile() to send a file to an AF_ALG socket
>> for hashing.
>
> Jens, any comments on this patch?
>
>> /* md5sum2.c */
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <unistd.h>
>> #include <string.h>
>> #include <fcntl.h>
>> #include <sys/socket.h>
>> #include <sys/stat.h>
>> #include <sys/types.h>
>> #include <linux/if_alg.h>
>>
>> int main(int argc, char **argv)
>> {
>>        int sk = socket(AF_ALG, SOCK_SEQPACKET, 0);
>>        struct stat st;
>>        struct sockaddr_alg sa = {
>>                .salg_family = AF_ALG,
>>                .salg_type = "hash",
>>                .salg_name = "md5",
>>        };
>>        int n;
>>
>>        bind(sk, (struct sockaddr*)&sa, sizeof(sa));
>>
>>        for (n = 1; n < argc; n++) {
>>                int size;
>>                int offset = 0;
>>                char buf[4096];
>>                int fd;
>>                int sko;
>>                int i;
>>
>>                fd = open(argv[n], O_RDONLY);
>>                sko = accept(sk, NULL, 0);
>>                fstat(fd, &st);
>>                size = st.st_size;
>>                sendfile(sko, fd, &offset, size);
>>                size = read(sko, buf, sizeof(buf));
>>                for (i = 0; i < size; i++)
>>                        printf("%2.2x", buf[i]);
>>                printf("  %s\n", argv[n]);
>>                close(fd);
>>                close(sko);
>>        }
>>        exit(0);
>> }
>>
>> Test below is done using official linux patch files. First result is
>> with a software based md5sum. Second result is with the program above.
>>
>> root@vgoip:~# ls -l patch-3.6.*
>> -rw-r--r--    1 root     root         64011 Aug 24 12:01 patch-3.6.2.gz
>> -rw-r--r--    1 root     root         94131 Aug 24 12:01 patch-3.6.3.gz
>>
>> root@vgoip:~# md5sum patch-3.6.*
>> b3ffb9848196846f31b2ff133d2d6443  patch-3.6.2.gz
>> c5e8f687878457db77cb7158c38a7e43  patch-3.6.3.gz
>>
>> root@vgoip:~# ./md5sum2 patch-3.6.*
>> b3ffb9848196846f31b2ff133d2d6443  patch-3.6.2.gz
>> 5fd77b24e68bb24dcc72d6e57c64790e  patch-3.6.3.gz
>>
>>
>> After investivation, it appears that sendfile() sends the files by blocks
>> of 64kbytes (16 times PAGE_SIZE). The problem is that at the end of each
>> block, the SPLICE_F_MORE flag is missing, therefore the hashing operation
>> is reset as if it was the end of the file.
>>
>> This patch adds SPLICE_F_MORE to the flags when more data is pending.
>>
>> With the patch applied, we get the correct sums:
>>
>> root@vgoip:~# md5sum patch-3.6.*
>> b3ffb9848196846f31b2ff133d2d6443  patch-3.6.2.gz
>> c5e8f687878457db77cb7158c38a7e43  patch-3.6.3.gz
>>
>> root@vgoip:~# ./md5sum2 patch-3.6.*
>> b3ffb9848196846f31b2ff133d2d6443  patch-3.6.2.gz
>> c5e8f687878457db77cb7158c38a7e43  patch-3.6.3.gz
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>> ---
>> v2: no change, only new commit text
>>
>> fs/splice.c | 7 ++++++-
>> 1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/splice.c b/fs/splice.c
>> index 476024b..fe61723 100644
>> --- a/fs/splice.c
>> +++ b/fs/splice.c
>> @@ -1161,7 +1161,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
>>        long ret, bytes;
>>        umode_t i_mode;
>>        size_t len;
>> -       int i, flags;
>> +       int i, flags, more;
>>
>>        /*
>>         * We require the input being a regular file, as we don't want to
>> @@ -1204,6 +1204,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
>>         * Don't block on output, we have to drain the direct pipe.
>>         */
>>        sd->flags &= ~SPLICE_F_NONBLOCK;
>> +       more = sd->flags & SPLICE_F_MORE;
>>
>>        while (len) {
>>                size_t read_len;
>> @@ -1216,6 +1217,10 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
>>                read_len = ret;
>>                sd->total_len = read_len;
>>
>> +               if (read_len < len)
>> +                       sd->flags |= SPLICE_F_MORE;
>> +               else if (!more)
>> +                       sd->flags &= ~SPLICE_F_MORE;
>>                /*
>>                 * NOTE: nonblocking mode only applies to the input. We
>>                 * must not do the output in nonblocking mode as then we
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
