From: David Howells <dhowells@redhat.com>
Subject: Re: [V2][PATCH 1/2] PKCS#7: Fix kernel panic when referring to the empty AuthorityKeyIdentifier
Date: Sun, 17 Jul 2016 23:58:41 +0100
Message-ID: <31800.1468796321@warthog.procyon.org.uk>
References: <57898E6A.5080101@windriver.com> <1468416937-21237-1-git-send-email-jia.zhang@windriver.com> <3760.1468594137@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, bhe@redhat.com, vgoyal@redhat.com,
	kexec@lists.infradead.org, linux-crypto@vger.kernel.org
To: Lans Zhang <jia.zhang@windriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbcGQW6o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Jul 2016 18:58:44 -0400
In-Reply-To: <57898E6A.5080101@windriver.com>
Content-ID: <31799.1468796321.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Lans Zhang <jia.zhang@windriver.com> wrote:

> Let me know if I need to add this comment to commit header.

I've done that.

David
