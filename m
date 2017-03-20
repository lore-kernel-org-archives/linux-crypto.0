From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH v4] IV Generation algorithms for dm-crypt
Date: Mon, 20 Mar 2017 20:08:19 +0530
Message-ID: <CAHv-k_9xv3MH8VtNnN=bZOwNnMVHie+yQz9uyd+S-=qReGXM=g@mail.gmail.com>
References: <1486463731-6224-1-git-send-email-binoy.jayan@linaro.org>
 <CAOtvUMcN8s886978vE6T=AE79KkZsLBnXsmhewnb5PB0UyAG3A@mail.gmail.com>
 <CAHv-k_8rgArzV2uQ64h1ZTNRpssX1jMf=RwuPoBmsjQ0FhCsWA@mail.gmail.com>
 <68f70534-a309-46ba-a84d-8acc1e6620e5@gmail.com> <CAOtvUMf3c0fUjABmbfMrbs0W4gyhKVZyc_tZH3rQg65zF18YMg@mail.gmail.com>
 <b563eb97-82ba-69d2-c4c5-66bc716a7507@gmail.com> <CAOtvUMePYT7OJDKL7i0y3y6Jvqsxyx6Je6g9aGKVq6PLZ_-Z8w@mail.gmail.com>
 <2aef6e54-805f-e09b-ae66-c198f8c05335@gmail.com> <c835926e-c2bd-8a52-34db-6c605301bc2b@gmail.com>
 <CAOtvUMdrQA4okKhiCyVmosQ4Oc2PHO4k4wLrDz-_fCyWB1rWBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Milan Broz <gmazyland@gmail.com>, Oded <oded.golombek@arm.com>,
        Ofir <Ofir.Drang@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>,
        Ondrej Mosnacek <omosnace@redhat.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOtvUMdrQA4okKhiCyVmosQ4Oc2PHO4k4wLrDz-_fCyWB1rWBw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 6 March 2017 at 20:08, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>
> I gave it a spin on a x86_64 with 8 CPUs with AES-NI using cryptd and
> on Arm  using CryptoCell hardware accelerator.
>
> There was no difference in performance between 512 and 4096 bytes
> cluster size on the x86_64 (800 MB loop file system)
>
> There was an improvement in latency of 3.2% between 512 and 4096 bytes
> cluster size on the Arm. I expect the performance benefits for this
> test for Binoy's patch to be the same.
>
> In both cases the very naive test was a simple dd with block size of
> 4096 bytes or the raw block device.
>
> I do not know what effect having a bigger cluster size would have on
> have on other more complex file system operations.
> Is there any specific benchmark worth testing with?


The multiple instances issue in /proc/crypto is fixed. It was because of
the IV code itself modifying the algorithm name inadvertently in the
global crypto algorithm lookup table when it was splitting up
"plain(cbc(aes))" into "plain" and "cbc(aes)" so as to invoke the child
algorithm.

I ran a few tests with dd, bonnie and FIO under Qemu - x86 using the
automated script [1] that I wrote to make the testing easy.
The tests were done on software implementations of the algorithms
as the real hardware was not available with me. According to the test,
I found that the sequential reads and writes have a good improvement
(5.7 %) in the data rate with the proposed solution while the random
reads shows a very little improvement. When tested with FIO, the
random writes also shows a small improvement (2.2%) but the random
reads show a little deterioration in performance (4 %).

When tested in arm hardware, only the sequential writes with bonnie
shows improvement (5.6%). All other tests shows degraded performance
in the absence of crypto hardware.

[1] https://github.com/binoyjayan/utilities/blob/master/utils/dmtest
Dependencies: dd [Full version], bonnie, fio

Thanks,
Binoy
