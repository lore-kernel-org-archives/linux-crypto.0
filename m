From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 1/4] ASN.1: Fix handling of CHOICE in ASN.1 compiler
Date: Thu, 6 Aug 2015 11:45:56 +1000 (AEST)
Message-ID: <alpine.LRH.2.20.1508061142580.11873@namei.org>
References: <20150805131810.8933.59566.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: keyrings@linux-nfs.org, marcel@holtmann.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tundra.namei.org ([65.99.196.166]:33479 "EHLO namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbbHFBqj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 21:46:39 -0400
In-Reply-To: <20150805131810.8933.59566.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 5 Aug 2015, David Howells wrote:

> Fix the handling of CHOICE types in the ASN.1 compiler to make SEQUENCE and
> SET elements in a CHOICE be correctly rendered as skippable and conditional
> as appropriate.

What are the security implications of these bugs?

It's pretty late in the -rc cycle.


-- 
James Morris
<jmorris@namei.org>
