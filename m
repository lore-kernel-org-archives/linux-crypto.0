From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/4] ASN.1: Fix handling of CHOICE in ASN.1 compiler
Date: Thu, 06 Aug 2015 06:33:36 +0100
Message-ID: <8166.1438839216@warthog.procyon.org.uk>
References: <alpine.LRH.2.20.1508061142580.11873@namei.org> <20150805131810.8933.59566.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, marcel@holtmann.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org
To: James Morris <jmorris@namei.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794AbbHFFdn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Aug 2015 01:33:43 -0400
In-Reply-To: <alpine.LRH.2.20.1508061142580.11873@namei.org>
Content-ID: <8165.1438839216.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

James Morris <jmorris@namei.org> wrote:

> What are the security implications of these bugs?

I've fed them various bits of butchered ASN.1 and observed the effects as well
as checking what happens in the code.  I don't think there are any security
implications.  I've outlined my reasoning in each  patch description.

David
