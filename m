From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Crypto Update for 4.2
Date: Tue, 23 Jun 2015 19:11:19 -0700
Message-ID: <CA+55aFyQW-Em8weHOBDVYw08H=-RfbeXJg61Zv6T-35rTdXB+g@mail.gmail.com>
References: <20130907035544.GA22658@gondor.apana.org.au>
	<20131107080131.GA32307@gondor.apana.org.au>
	<20140123115319.GA20602@gondor.apana.org.au>
	<20140401100001.GA12386@gondor.apana.org.au>
	<20140605062336.GA14440@gondor.apana.org.au>
	<20140804130339.GA1178@gondor.apana.org.au>
	<20141007131826.GA29688@gondor.apana.org.au>
	<20141211125119.GA12380@gondor.apana.org.au>
	<20150214094328.GA7457@gondor.apana.org.au>
	<20150415033951.GA1406@gondor.apana.org.au>
	<20150622084457.GA7806@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150622084457.GA7806@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 22, 2015 at 1:44 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Here is the crypto update for 4.2:

Hmm. I noticed a new annoyance:

I get this at bootup:

  [  +0.001504] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
  [  +0.002233] alg: aead: setkey failed on test 1 for
rfc4106-gcm-aesni: flags=0

in general, I'm not at all convinced that the crypto tests make sense.
I absolutely destest that horrid "testmgr.h" file that is 32
_thousand_ lines of noise. And now it's apparently complaining about a
missing test, so that nasty mess will presumably grow.

Could you not make the test infrastructure be something that gets run
in user space?

                    Linus
