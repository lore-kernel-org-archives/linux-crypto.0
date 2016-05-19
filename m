From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 0/3] crypto: caam - add support for RSA algorithm
Date: Thu, 19 May 2016 23:51 +0200
Message-ID: <2370625.CgO9A4qjJ6@positron.chronox.de>
References: <1463660118-19188-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	horia.geanta@nxp.com
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39666 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbcESVu6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 May 2016 17:50:58 -0400
In-Reply-To: <1463660118-19188-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 19. Mai 2016, 15:15:15 schrieb Tudor Ambarus:

Hi Tudor,

as I am looking into the RSA countermeasures, I am wondering how much of 
countermeasures are actually applied inside hardware implementations. Can you 
please point me to or illustrate any countermeasures your implementation does?

The goal for my question is to identify whether we need to have a generic 
implementation one that is enabled on a per-implementation basis.


Ciao
Stephan
