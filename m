From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 08/10] crypto: scatterwak - Add scatterwalk_sg_copychunks
Date: Fri, 18 Mar 2016 20:52:38 +0100
Message-ID: <23909406.3cUV6IQfBk@tauon.atsec.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com> <1458325927-14737-8-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, tadeusz.struk@intel.com,
	linux-crypto@vger.kernel.org, horia.geanta@nxp.com
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33156 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbcCRTwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 15:52:41 -0400
In-Reply-To: <1458325927-14737-8-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 18. M=E4rz 2016, 20:32:05 schrieb Tudor Ambarus:

Hi Tudor,

> This patch adds the function scatterwalk_sg_copychunks which writes
> a chunk of data from a scatterwalk to another scatterwalk.
> It will be used by caam driver to remove the leading zeros of RSA's
> algorithm output.

The following is unrelated to the patch, but regarding your statement: =
I=20
lately read that leading zeros are skipped for RSA. Why is that impleme=
nted=20
this way? The driver of my question is side channels. Don't we open our=
selves=20
up to side channel attacks when forgetting about zeros?

Heck, by simply processing zeros in a modular exponentiation (of a priv=
ate=20
key), we have side channels, because processing of zeros is faster than=
 ones.=20
I am starting to wonder whether this magic with the leading zeros is go=
ing to=20
hurt us?

Ciao
Stephan
