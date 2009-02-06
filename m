From: Frank Seidel <fseidel@suse.de>
Subject: Re: [PATCH] crypto: add missing KERN_* constants to printks
Date: Fri, 06 Feb 2009 15:59:31 +0100
Message-ID: <498C5053.4010809@suse.de>
References: <498C46DE.8040700@suse.de> <20090206145838.GA28197@x200.localdomain> <498C4F2E.1070204@f-seidel.de> <20090206150315.GA28249@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Frank Seidel <frank@f-seidel.de>,
	linux kernel <linux-kernel@vger.kernel.org>,
	akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	jarod@redhat.com
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759001AbZBFPAX@vger.kernel.org>
In-Reply-To: <20090206150315.GA28249@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Alexey Dobriyan schrieb:
> Some messages there were truly debugging and some clearly weren't
> WARNING, but INFO.

Yes, i also thought so, but i didn't venture to change it
to i think it looks like. And as bevor they also were all at
the same (unspecified/default) level...
Do you think its worth/i should redo it and adapt the loglevel
more appropriate?

Thanks,
Frank
