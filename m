From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: DH & KDF
Date: Wed, 6 Jul 2016 10:27:10 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1607061021430.2149@mjmartin-mac01.local>
References: <47344115.AvlVGsj60Z@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: David Howells <dhowells@redhat.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35121 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150AbcGFR1M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Jul 2016 13:27:12 -0400
In-Reply-To: <47344115.AvlVGsj60Z@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Stephan -

On Sat, 2 Jul 2016, Stephan Mueller wrote:

> I am currently working on adding the KDF support to the DH key service. The
> plan is to make it consistent with SP800-56A section 5.8.1 and yet open enough
> to allow other use cases with other KDFs.
>
> Is there already a test tool that already exercises the DH logic that I can
> use to test my extension?

There are DH tests in the 'next' branch for keyutils:

https://git.kernel.org/cgit/linux/kernel/git/dhowells/keyutils.git/log/?h=next

An additional patch (waiting for review) is also required ("TEST: Use 
correct variable when checking for DH functionality"). I'll forward that 
to you.

--
Mat Martineau
Intel OTC
