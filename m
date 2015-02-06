From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/7] Enabling VMX module for PPC64
Date: Fri, 6 Feb 2015 14:41:39 -0200
Message-ID: <20150206164139.GA13760@bluepex.com>
References: <20150205172126.GA15218@bluepex.com>
 <1423173503.32511.16.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:50732 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609AbbBFQlq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Feb 2015 11:41:46 -0500
Received: from /spool/local
	by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <leosilva@linux.vnet.ibm.com>;
	Fri, 6 Feb 2015 14:41:44 -0200
Content-Disposition: inline
In-Reply-To: <1423173503.32511.16.camel@x220>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks for the advices Paul.
Resending patch set as V2.

> > +vmx-crypto-objs := vmx.o aesp8-ppc.o ghashp8-ppc.o aes.o aes_cbc.o aes_ctr.o ghash.o
> > +
> > +ifeq ($(CONFIG_PPC64),y)
> 
> Can this test ever fail?
In fact we don't need this first IF, since it already depends on
PPC64.


---
Leonidas.
