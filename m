Return-Path: <SRS0=8/la=PM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from a.mx.secunet.com ([62.96.220.36]:59296 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbfADIeW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Jan 2019 03:34:22 -0500
Date: Fri, 4 Jan 2019 09:34:19 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Harsh Jain <harsh@chelsio.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        <atul.gupta@chelsio.com>, <harshjain.prof@gmail.com>
Subject: Re: IPSec ESN: Packets decryption fail with ESN enabled connection
Message-ID: <20190104083419.GG3581@gauss3.secunet.de>
References: <93ad9333-1e77-58fc-3f47-a967294fe188@chelsio.com>
 <f1a91df3-c191-7ce1-1721-c94ca4322aa9@chelsio.com>
 <20190102125109.az6n4rr4m2hng6d6@gondor.apana.org.au>
 <692a865e-1903-bff8-a8f4-aface07a96ac@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <692a865e-1903-bff8-a8f4-aface07a96ac@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 03, 2019 at 04:16:56PM +0530, Harsh Jain wrote:
> 
> On 02-01-2019 18:21, Herbert Xu wrote:
> > Does this occur if you use software crypto on the receiving end
> > while keeping the sending end unchanged?
> 
> I tried with "authencesn(hmac(sha1-ssse3),cbc(aes-asm))" on both sides.
> 
> Server : iperf  -s  -w 512k  -p 20002
> 
> Client : iperf  -t 60 -w 512k -l 2048 -c 1.0.0.96 -P 32 -p 20002
> 
> >
> > If not then I would start debugging this within your driver.
> 
> ESP Packet whose's sequence No. is out of window gets dropped with EBADMSG.  It seems that "xfrm_replay_seqhi" intentionally increments the "seq_hi" to fail verification for Out of seq packet.

Yes, this is defined in RFC 4303 Appendix A2.2.
