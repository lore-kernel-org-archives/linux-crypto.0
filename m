From: David Howells <dhowells@redhat.com>
Subject: Re: [V2][PATCH 1/2] PKCS#7: Fix kernel panic when referring to the empty AuthorityKeyIdentifier
Date: Fri, 15 Jul 2016 15:48:57 +0100
Message-ID: <3760.1468594137@warthog.procyon.org.uk>
References: <1468416937-21237-1-git-send-email-jia.zhang@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, bhe@redhat.com, vgoyal@redhat.com,
	kexec@lists.infradead.org, linux-crypto@vger.kernel.org
To: Lans Zhang <jia.zhang@windriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbcGOOtA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jul 2016 10:49:00 -0400
In-Reply-To: <1468416937-21237-1-git-send-email-jia.zhang@windriver.com>
Content-ID: <3759.1468594137.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Lans Zhang <jia.zhang@windriver.com> wrote:

> This fix resolves the following kernel panic if the empty
> AuthorityKeyIdentifier employed.

It should be noted that this is only an issue if DEBUG is #defined at the top
of pkcs7_verify.c as the crash happens in a pr_debug() statement.

David
