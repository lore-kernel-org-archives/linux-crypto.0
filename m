From: David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 2/5] KEYS: Provide keyctls to drive the new key type ops for asymmetric keys
Date: Thu, 05 May 2016 10:57:23 +0100
Message-ID: <6186.1462442243@warthog.procyon.org.uk>
References: <20160504164339.28371.27174.stgit@warthog.procyon.org.uk> <20160504164324.28371.29267.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, linux-crypto@vger.kernel.org,
	kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	keyrings@vger.kernel.org, dwmw2@infradead.org
To: mathew.j.martineau@linux.intel.com, tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190AbcEEJ50 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 05:57:26 -0400
In-Reply-To: <20160504164339.28371.27174.stgit@warthog.procyon.org.uk>
Content-ID: <6185.1462442243.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I've pushed a fix to #include <linux/err.h> in keyctl_pkey.c into the git
tree.

David
