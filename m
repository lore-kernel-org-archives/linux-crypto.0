From: David Howells <dhowells@redhat.com>
Subject: Re: key retention service: DH support
Date: Tue, 24 May 2016 08:04:28 +0100
Message-ID: <27639.1464073468@warthog.procyon.org.uk>
References: <1522711.HEekpKlqDU@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, mathew.j.martineau@linux.intel.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbcEXHEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 May 2016 03:04:32 -0400
In-Reply-To: <1522711.HEekpKlqDU@positron.chronox.de>
Content-ID: <27638.1464073468.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephan Mueller <smueller@chronox.de> wrote:

> With the new DH support for the key retention service, support for DH derived 
> keys pops up.
> 
> The implementation in security/keys/dh.c returns the DH shared secret straight 
> to the user space caller.
> 
> I implemented a KDF with that exact scenario already in mind: [1].
> 
> I am wondering whether the shared secret should be processed by a KDF before 
> returning the data to user space?
> 
> [1] http://www.chronox.de/kdf.html

Adding Mat to the cc list.  If we want to modify the new DH keyctl, we have a
very short time window in which to do so.

David
