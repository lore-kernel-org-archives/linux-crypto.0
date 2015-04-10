From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Fri, 10 Apr 2015 16:46:04 +0200
Message-ID: <5527E22C.9080909@iogearbox.net>
References: <20150318095345.GA12923@zoho.com> <1697288.aUGCRhyl06@tauon> <1428675960.3377.8.camel@stressinduktion.org> <2115964.QxtQ6rHSkc@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: mancha <mancha1@zoho.com>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dborkman@redhat.com
To: Stephan Mueller <smueller@chronox.de>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:43939 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932755AbbDJOq1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Apr 2015 10:46:27 -0400
In-Reply-To: <2115964.QxtQ6rHSkc@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/10/2015 04:36 PM, Stephan Mueller wrote:
> Am Freitag, 10. April 2015, 16:26:00 schrieb Hannes Frederic Sowa:
...
>> I suspected a problem in how volatile with non-present output args could
>> be different, but this seems not to be the case.
>>
>> I would contact llvm/clang mailing list and ask. Maybe there is a
>> problem? It seems kind of strange to me...

+1

> Do you really think this is a compiler issue?

If clang/LLVM advertises "GCC compatibility", then this would
certainly be a different behavior.
