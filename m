From: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Wed, 14 Feb 2007 21:35:40 -0800
Message-ID: <200702142135.40832.agruen@suse.de>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <20070214194112.5bec3110.akpm@linux-foundation.org> <20070215041345.GA15654@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	torvalds@linux-foundation.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, arjan@infradead.org,
	linux-crypto@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:38647 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXBOFf7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Feb 2007 00:35:59 -0500
In-Reply-To: <20070215041345.GA15654@redhat.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wednesday 14 February 2007 20:13, Dave Jones wrote:
> I've not investigated it, but I hear rumours that suse has something
> similar.

Actually, no. We don't belive that module signing adds significant value, and 
it also doesn't work well with external modules. (The external modules we 
really care about are GPL ones; it gives us a way to update drivers without 
pushing out entirely new kernels.)

Cheers,
Andreas
