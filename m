From: Cristian Stoica <cristian.stoica@nxp.com>
Subject: Re: [PATCH 1/3] crypto: authenc - add TLS type encryption
Date: Wed, 9 Mar 2016 08:18:12 +0000
Message-ID: <AM4PR0401MB1876509BEA44E70B77BA3BAAE7B30@AM4PR0401MB1876.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Tadeusz,

>> SSL/TLS is prone to this implementation issue and many user-space libraries got this wrong. It would be good to see >>some numbers to back-up the claim of timing differences as not being an issue for this one.

>It is hard to get the implementation right when the protocol design is error prone.
>Later we should run some tests on it and see how relevant will this be for a remote timing attack.

Why later and who will do it?

If it's only a proof of concept, then it's a bad idea. You are practically advertising a use-it-but-cross-your-fingers implementation.
If you intend to submit another hardware driver which _is_ constant time, then it is even more a bad idea. The end-user doesn't know which driver is actually running and if it is resistant or not to timing attacks.

Cristian S.
