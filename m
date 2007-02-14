From: Michael Halcrow <mhalcrow@us.ibm.com>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Wed, 14 Feb 2007 15:32:00 -0600
Message-ID: <20070214213200.GA4852@us.ibm.com>
References: <Pine.LNX.4.64.0702141121030.20368@woody.linux-foundation.org> <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <7291.1171482057@redhat.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	akpm@linux-foundation.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, davej@redhat.com,
	arjan@infradead.org, linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:32857 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932646AbXBNVcF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Feb 2007 16:32:05 -0500
Content-Disposition: inline
In-Reply-To: <7291.1171482057@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 14, 2007 at 07:40:57PM +0000, David Howells wrote:
> Hashing, yes; encryption, yes; signature checking: no from what I
> can see.
> 
> It's possible that I can share code with eCryptFS, though at first
> sight that doesn't seem to overlap with what I want to do.

Right now, eCryptfs just delegates its modular exponentiation
operations to a userspace daemon. If RSA ever finds its way into the
kernel, I might tweak eCryptfs to use that instead for some of the
public key operations.

Mike
