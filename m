From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Questions about the Crypto API
Date: Sat, 10 Aug 2013 11:15:41 +1000
Message-ID: <20130810011541.GA6549@gondor.apana.org.au>
References: <20130805202557.GE5752@oc8526070481.ibm.com>
 <20130806070010.GB19754@gondor.apana.org.au>
 <065BBB7616BCE543832A2EF096986B940A05ADCD@039-SN2MPN1-011.039d.mgd.msft.net>
 <20130809125513.GA7674@oc8526070481.ibm.com>
 <A83C99F8370D4D42BEB2D2B3153A6BBC23D55A6E@NASANEXD02C.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marcelo Cerri <mhcerri@linux.vnet.ibm.com>,
	Garg Vakul-B16394 <B16394@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:48273 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968314Ab3HJBQ5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Aug 2013 21:16:57 -0400
Content-Disposition: inline
In-Reply-To: <A83C99F8370D4D42BEB2D2B3153A6BBC23D55A6E@NASANEXD02C.na.qualcomm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 09, 2013 at 01:09:12PM +0000, Hsieh, Che-Min wrote:
> Marcelo/Herbert:
> 
> I believe It is. Herbert, please correct me if I am wrong.
> A single tfm is used as a user context to crypto, so to speak. But a user is not a thread.
> Let us use ipsec as example.
> For each security association (SA), it will take up a tfm.
> Assume I have IP sec setup between my local host and remote host.  I might have two SA's, one for each direction.
> Now, I might run ping. Simultaneously, I might run iperf. I might run a lot of different things  between these two ip hosts.
> But only two tfm's are involved.
> I have seen this happening   in our system with ipsec setup as described above.
> While an  async request is outstanding in the driver,  another request is  issued to the same driver for the same tfm.

Yes you're absolutely right.

Unless I've misunderstood Marcelo's question is different from
what Garg was asking.

Marcelo: The tfm, be it blkcipher or ablkcipher can always be used
in parallel by the user on different CPUs.  For example, IPsec may
receive two packets on two CPUs through the same SA, in which case
decryption will be carried out in parallel.

Garg: For any tfm, blkcipher or ablkcipher, they must return results
in the order they were given.  For a blkcipher which is synchronous,
this is always true by definition since we return only after the
result has been completed.  For an async ablkcipher, this means that
if you receive two requests on the same CPU, then the first request
must be served and completed before the second request's completion
can be initiated.

Sorry for any confusion this might have caused.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
