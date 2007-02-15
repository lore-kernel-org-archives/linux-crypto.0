From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Thu, 15 Feb 2007 15:35:50 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0702151530260.14458@scrub.home>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: torvalds@osdl.org, akpm@osdl.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, davej@redhat.com,
	arjan@infradead.org, linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965503AbXBOOhK@vger.kernel.org>
In-Reply-To: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On Wed, 14 Feb 2007, David Howells wrote:

> Now, this is not a complete solution by any means: the core kernel is not
> protected, and nor are /dev/mem or /dev/kmem, but it denies (or at least
> controls) one relatively simple attack vector.

This is really the weak point - it offers no advantage over an equivalent 
implementation in user space (e.g. in the module tools). So why has to be 
done in the kernel?

bye, Roman
