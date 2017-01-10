From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: Re: [PATCH v2 4/4] fs/pstore: fs/squashfs: Change usage of LZ4 to comply with new LZ4 module version
Date: Tue, 10 Jan 2017 10:45:00 +0100
Message-ID: <1484041500-6405-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
References: <CAGXu5jKqMUMU8DbnE=AamrCp_-JN7sGRCpaGMps16X_TshfK+Q@mail.gmail.com>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, anton@enomsg.org, ccross@android.com,
        tony.luck@intel.com, phillip@squashfs.org.uk,
        Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
To: keescook@chromium.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jKqMUMU8DbnE=AamrCp_-JN7sGRCpaGMps16X_TshfK+Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Kees,

On 01/07/2017 10:33 PM, Kees Cook wrote:
 >On Sat, Jan 7, 2017 at 8:55 AM, Sven Schmidt
 ><4sschmid@informatik.uni-hamburg.de> wrote:
 >> This patch updates fs/pstore and fs/squashfs to use the updated functions from
 >> the new LZ4 module.
 >>
 >> Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
 >> ---
 >>  fs/pstore/platform.c      | 14 ++++++++------
 >>  fs/squashfs/lz4_wrapper.c | 12 ++++++------
 >>  2 files changed, 14 insertions(+), 12 deletions(-)
 >>
 >> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
 >> index 729677e..a0d8ca8 100644
 >> --- a/fs/pstore/platform.c
 >> +++ b/fs/pstore/platform.c
 >> @@ -342,31 +342,33 @@ static int compress_lz4(const void *in, void *out, size_t inlen, size_t outlen)
 >>  {
 >>         int ret;
 >>
 >> -       ret = lz4_compress(in, inlen, out, &outlen, workspace);
 >> +       ret = LZ4_compress_default(in, out, inlen, outlen, workspace);
 >>         if (ret) {
 >> +               // ret is 0 means an error occured
 >
 >If that's true, then shouldn't the "if" logic be changed? Also, here
 >and in all following comments are C++ style instead of kernel C-style.
 >This should be "/* ret == 0 means an error occured */", though really,
 >that should be obvious from the code and the comment isn't really
 >needed.

indeed, it should. I fixed that one.

 >>                 pr_err("lz4_compress error, ret = %d!\n", ret);
 >If it's always going to be zero here, is there a better place to get
 >details on why it failed?

 It is always going to be zero. Honestly, after looking at the current LZ4 in kernel again
 I don't get why there actually was a need to print the return value since lz4_compress
 will (as far as I see) always return -1 in case of an error while the new lz4_compress_fast/default
 will return 0 in such case. Maybe I should just stick with the error?

 Thanks,

 Sven
