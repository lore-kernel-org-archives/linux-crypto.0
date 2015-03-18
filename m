From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Wed, 18 Mar 2015 18:49:55 +0100
Message-ID: <5509BAC3.6090201@iogearbox.net>
References: <20150318095345.GA12923@zoho.com> <550972A7.9030100@iogearbox.net> <1426691374.2212055.242060697.4DDF89CA@webmail.messagingengine.com> <4937031.1sk5yglzr8@tauon> <20150318171402.GB24195@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dborkman@redhat.com,
	cesarb@cesarb.eti.br
To: mancha <mancha1@zoho.com>, Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:32839 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbbCRRuB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 13:50:01 -0400
In-Reply-To: <20150318171402.GB24195@zoho.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/18/2015 06:14 PM, mancha wrote:
...
> Patch 0001 fixes the dead store issue in memzero_explicit().

Thanks! I have issued the fix for the memzero bug to Herbert in
your authorship as discussed, also giving some more context.

For the 2nd issue, lets wait for Cesar.

Thanks again!
