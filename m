From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 5/6] [RFC] crypto/testmgr: add null test for 842 algorithm
Date: Fri, 03 Jul 2015 08:26:46 +0200
Message-ID: <2341214.PM4pjiXfyv@tauon.atsec.com>
References: <20150702223800.GA1712@linux.vnet.ibm.com> <20150702224119.GF1712@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Dan Streetman <ddstreet@us.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	gustavold@linux.vnet.ibm.com
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47894 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbbGCG0y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Jul 2015 02:26:54 -0400
In-Reply-To: <20150702224119.GF1712@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 2. Juli 2015, 15:41:19 schrieb Nishanth Aravamudan:

Hi Nishanth,

>Currently, when the nx-842-pseries driver loads, the following message
>is emitted:
>
>alg: No test for 842 (842-nx)
>
>It seems like the simplest way to fix this message (other than adding a
>proper test) is to just insert the null test into the list in the
>testmgr.
>
>Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
>
>---
> crypto/testmgr.c | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/crypto/testmgr.c b/crypto/testmgr.c
>index d0a42bd3aae9..ff0f76e0d0b4 100644
>--- a/crypto/testmgr.c
>+++ b/crypto/testmgr.c
>@@ -1982,6 +1982,9 @@ static int alg_test_null(const struct alg_test_desc
>*desc, /* Please keep this list sorted by algorithm name. */
> static const struct alg_test_desc alg_test_descs[] = {
> 	{
>+		.alg = "842",
>+		.test = alg_test_null,
>+	}, {
> 		.alg = "__cbc-cast5-avx",
> 		.test = alg_test_null,

As this is a compression algo, it is safe to add fips_allowed = 1 here as 
otherwise the algo is not available in fips=1

> 	}, {


Ciao
Stephan
