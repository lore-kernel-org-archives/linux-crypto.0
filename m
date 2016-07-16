From: Lans Zhang <jia.zhang@windriver.com>
Subject: Re: [V2][PATCH 1/2] PKCS#7: Fix kernel panic when referring to the
 empty AuthorityKeyIdentifier
Date: Sat, 16 Jul 2016 09:31:22 +0800
Message-ID: <57898E6A.5080101@windriver.com>
References: <1468416937-21237-1-git-send-email-jia.zhang@windriver.com> <3760.1468594137@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <bhe@redhat.com>, <vgoyal@redhat.com>, <kexec@lists.infradead.org>,
	<linux-crypto@vger.kernel.org>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail5.windriver.com ([192.103.53.11]:49180 "EHLO mail5.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbcGPBbz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jul 2016 21:31:55 -0400
In-Reply-To: <3760.1468594137@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/15/2016 10:48 PM, David Howells wrote:
> Lans Zhang<jia.zhang@windriver.com>  wrote:
>
>> This fix resolves the following kernel panic if the empty
>> AuthorityKeyIdentifier employed.
>
> It should be noted that this is only an issue if DEBUG is #defined at the top
> of pkcs7_verify.c as the crash happens in a pr_debug() statement.
>

Yep and your previous analysis is correct.

Let me know if I need to add this comment to commit header.

Cheers,
Jia

> David
>
