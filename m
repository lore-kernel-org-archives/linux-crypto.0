Return-Path: <SRS0=M78F=PK=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37576 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfABMvT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Jan 2019 07:51:19 -0500
Date: Wed, 2 Jan 2019 20:51:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <harsh@chelsio.com>
Cc: steffen.klassert@secunet.com, davem@davemloft.net,
        netdev@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        atul.gupta@chelsio.com, harshjain.prof@gmail.com
Subject: Re: IPSec ESN: Packets decryption fail with ESN enabled connection
Message-ID: <20190102125109.az6n4rr4m2hng6d6@gondor.apana.org.au>
References: <93ad9333-1e77-58fc-3f47-a967294fe188@chelsio.com>
 <f1a91df3-c191-7ce1-1721-c94ca4322aa9@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1a91df3-c191-7ce1-1721-c94ca4322aa9@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 26, 2018 at 03:16:29PM +0530, Harsh Jain wrote:
> +linux-crypto
> 
> On 26-12-2018 14:54, Harsh Jain wrote:
> > Hi All,
> >
> > Kernel version on both machines: 4.19.7.
> >
> > Packet drops with EBADMSG is observed on receive end of connection. It seems that sometimes crypto driver receives packet with wrong "seq_hi" value in AAD. See below the dump of assoc data for 1 such instance.
> >
> > [  380.823454] assoclen 8th byte 1 clen 1464 op 1  ==> High byte of ESN
> > [  380.828398] authsize 12 cryptlen 1464
> > [  380.832637] dt00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 06 ==> Decrypted data seems correct,last byte is proto(06 TCP)
> > [  380.840215] dt00000010: bf ee 4f 80 a4 7f 2a 50 6a 5a 0b 10
> > [  380.846636] ass00000000: 0a bc d3 31 <00 00 00 01> 00 1c e5 ec 0e af 04 69 ==> ESN-Hi = 1
> > [  380.854316] ass00000010: a4 fc 08 ad
> >
> > Note: If I decrypt the same packet with ESN - Hi = 0. It Decrypt successfully means peer machine has used ESN-HI = 0 while encrypting.
> >
> > To debug further we added trace in "xfrm_replay_seqhi". Following was the output:
> >
> >  <idle>-0     [003] ..s.   380.967766: xfrm_replay_seqhi: seq_hi 0x 1 seq 0x 1ce5ec bottom 0x 1ce5ee replay seq 0x 1ce62d replay window 0x 40
> >
> > 1) Is this an expected variable with ESN enables connection?.
> >
> > 2) If packets are supposed to be dropped can't we avoid decryption overhead.
> >
> > Following logs are attached
> >
> > 1) dmesg log
> >
> > 2) debug patch used to reproduce the issue.
> >
> > 3) ftace log file
> >
> > 4) ip xfrm state list

Does this occur if you use software crypto on the receiving end
while keeping the sending end unchanged?

If not then I would start debugging this within your driver.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
