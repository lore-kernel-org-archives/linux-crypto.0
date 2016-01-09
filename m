From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 2/2] crypto: algif_hash - Require setkey before accept(2)
Date: Sat, 9 Jan 2016 11:15:21 +0100
Message-ID: <5690DDB9.4000401@gmail.com>
References: <CACT4Y+YOwOfRHOwJ=FA9aaL2cZ-PRhTvd_mCzxx2nnN_L3tygw@mail.gmail.com>
 <5687BA0F.3020104@gmail.com> <5687E19E.2070801@gmail.com>
 <1647086.cdlVYfuqk1@myon.chronox.de> <56883096.1020009@gmail.com>
 <20160103013126.GA30385@gondor.apana.org.au> <5688ED04.4090802@gmail.com>
 <20160104043518.GA4411@gondor.apana.org.au> <568A66B2.4090307@gmail.com>
 <20160108132826.GA5808@gondor.apana.org.au>
 <20160108133104.GA5838@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>,
	Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kcc@google.com, glider@google.com,
	edumazet@google.com, sasha.levin@oracle.com, keescook@google.com,
	Ondrej Kozina <okozina@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160108133104.GA5838@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 01/08/2016 02:31 PM, Herbert Xu wrote:
> Hash implementations that require a key may crash if you use
> them without setting a key.  This patch adds the necessary checks
> so that if you do attempt to use them without a key that we return
> -ENOKEY instead of proceeding.
> 
> This patch also adds a compatibility path to support old applications
> that do acept(2) before setkey.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reported-and-tested-by: Milan Broz <gmazyland@gmail.com>

(tested both patches, ditto for previous skcipher series)

Thanks,
Milan
