From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: KEYS: convert public key to the akcipher API
Date: Sat, 15 Aug 2015 20:08:12 +0200
Message-ID: <3295616.oBrs36mNlq@tauon.atsec.com>
References: <20150813035433.25108.3065.stgit@tstruk-mobl1> <20150813035439.25108.62457.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48088 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248AbbHOSIV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 15 Aug 2015 14:08:21 -0400
In-Reply-To: <20150813035439.25108.62457.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 12. August 2015, 20:54:39 schrieb Tadeusz Struk:

Hi Tadeusz,

>@@ -41,7 +41,7 @@ struct pkcs7_parse_context {
> static void pkcs7_free_signed_info(struct pkcs7_signed_info *sinfo)
> {
> 	if (sinfo) {
>-		mpi_free(sinfo->sig.mpi[0]);
>+		kfree(sinfo->sig.s);

kzfree?

> 		kfree(sinfo->sig.digest);

kzfree?

> 		kfree(sinfo->signing_cert_id);
> 		kfree(sinfo);

kzfree (due to ->msdigest)?


Ciao
Stephan
