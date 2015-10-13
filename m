From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Fixes for 4.3
Date: Tue, 13 Oct 2015 10:23:39 -0700
Message-ID: <CA+55aFz0ZdjpC_FpM6h=z_boK8HeKzgt_7Zm14TnrZYqx1SaUQ@mail.gmail.com>
References: <20140401100001.GA12386@gondor.apana.org.au>
	<20140605062336.GA14440@gondor.apana.org.au>
	<20140804130339.GA1178@gondor.apana.org.au>
	<20141007131826.GA29688@gondor.apana.org.au>
	<20141211125119.GA12380@gondor.apana.org.au>
	<20150214094328.GA7457@gondor.apana.org.au>
	<20150626102234.GA19393@gondor.apana.org.au>
	<20150908092502.GA8332@gondor.apana.org.au>
	<20150916103014.GA12315@gondor.apana.org.au>
	<20150926200133.GA19035@gondor.apana.org.au>
	<20151013121750.GA6408@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151013121750.GA6408@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 13, 2015 at 5:17 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This push fixes the following issues:
>
> * Fix AVX detection to prevent use of non-existent AESNI.
> * Some SPARC ciphers did not set their IV size which may lead
>   to memory corruption.

Hmm. It looks like you also quietly added a ahash fix this morning.

I took it despite it not being described or in the diffstat. But
please send new pull requests when you update a branch you asked me to
pull.

                    Linus
