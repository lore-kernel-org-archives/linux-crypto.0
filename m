From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH V2 0/3] Series short description
Date: Thu, 2 Mar 2017 15:29:48 -0600
Message-ID: <db068e9a-e058-edb0-06e8-a07bddd37476@amd.com>
References: <20170302212331.30959.44149.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
To: "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0053.outbound.protection.outlook.com ([104.47.32.53]:63855
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750709AbdCCFOi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Mar 2017 00:14:38 -0500
In-Reply-To: <20170302212331.30959.44149.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/02/2017 03:26 PM, Hook, Gary wrote:
> The following series:
> - Move verbose init messages to debug mode
> - Update the queue pointers in the event of an error
> - Simplify buffer management and eliminate an unused option

*sigh* That Subject line is supposed to read "Minor CCP improvements and 
clean-up".


>
> ---
>
> Gary R Hook (3):
>       crypto: ccp - Add SHA-2 384- and 512-bit support
>       crypto: ccp - Enable support for AES GCM on v5 CCPs
>       crypto: ccp - Enable 3DES function on v5 CCPs
>
>
>  drivers/crypto/ccp/Makefile                |    2
>  drivers/crypto/ccp/ccp-crypto-aes-galois.c |  257 ++++++++++++++
>  drivers/crypto/ccp/ccp-crypto-des3.c       |  254 ++++++++++++++
>  drivers/crypto/ccp/ccp-crypto-main.c       |   22 +
>  drivers/crypto/ccp/ccp-crypto-sha.c        |   22 +
>  drivers/crypto/ccp/ccp-crypto.h            |   44 ++
>  drivers/crypto/ccp/ccp-dev-v3.c            |    1
>  drivers/crypto/ccp/ccp-dev-v5.c            |   56 +++
>  drivers/crypto/ccp/ccp-dev.h               |   15 +
>  drivers/crypto/ccp/ccp-ops.c               |  522
> ++++++++++++++++++++++++++++
>  include/linux/ccp.h                        |   68 ++++
>  11 files changed, 1257 insertions(+), 6 deletions(-)
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-galois.c
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-des3.c
>
> --
> Signature

-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
