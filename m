From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 0/3] Key-agreement Protocol Primitives (KPP) API
Date: Wed, 11 May 2016 11:04:46 +0200
Message-ID: <2535192.8l4d6SEXNP@positron.chronox.de>
References: <1462951563-50042-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55160 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbcEKJEl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 May 2016 05:04:41 -0400
In-Reply-To: <1462951563-50042-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 11. Mai 2016, 08:26:00 schrieb Salvatore Benedetto:

Hi Salvatore,

> Changes from v5:
> * Fix ecdh loading in fips mode.

Thanks.

As I do not readily see how you solved the issue, may I ask for a pointer to 
the code that handles that?

Ciao
Stephan
