From: Michal Marek <mmarek@suse.com>
Subject: Re: [PATCH] X.509: Fix test for self-signed certificate
Date: Fri, 26 Feb 2016 13:51:51 +0100
Message-ID: <56D04A67.4070601@suse.com>
References: <1455197665-11199-1-git-send-email-mmarek@suse.com>
 <16658.1456325653@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbcBZMvy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Feb 2016 07:51:54 -0500
In-Reply-To: <16658.1456325653@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2016-02-24 15:54, David Howells wrote:
> Hi Michal,
> 
> I have the attached patch already in my queue.
> 
> David
> ---
> commit d19fcb825912c67e09e0575b95accaa42899e07f
> Author: David Howells <dhowells@redhat.com>
> Date:   Wed Feb 24 14:37:54 2016 +0000
> 
>     X.509: Don't treat self-signed keys specially

Hi David,

this solves my problem too, obviously. I thought the signature check for
self-signed certificates was a sort of consistency check.

Thanks,
Michal
