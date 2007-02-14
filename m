From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
Date: Wed, 14 Feb 2007 11:26:26 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0702141121030.20368@woody.linux-foundation.org>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: akpm@linux-foundation.org, herbert.xu@redhat.com,
	linux-kernel@vger.kernel.org, davej@redhat.com,
	arjan@infradead.org, linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41196 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932471AbXBNT0p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Feb 2007 14:26:45 -0500
In-Reply-To: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On Wed, 14 Feb 2007, David Howells wrote:
>
>  (1) A cut-down MPI library derived from GPG with error handling added.

Do we really need to add this?

Wouldn't it be much nicer to just teach people to use one of the existing 
signature things that we need for _other_ cases anyway, and already have 
merged?

(Of course, it's possible that none of the current crypto supports any 
signature checking at all - I didn't actually look. In which case my 
argument is pointless).

		Linus
