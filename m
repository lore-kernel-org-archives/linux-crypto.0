From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 04/16] PGP: Add definitions (RFC 4880) and packet parser [ver #2]
Date: Mon, 05 Dec 2011 11:21:26 +0000
Message-ID: <32725.1323084086@redhat.com>
References: <1323014582.7454.121.camel@deadeye> <20111129234258.13625.21153.stgit@warthog.procyon.org.uk> <20111129234348.13625.33435.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
	zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
	alan.cox@intel.com
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab1LELVm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Dec 2011 06:21:42 -0500
In-Reply-To: <1323014582.7454.121.camel@deadeye>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ben Hutchings <ben@decadent.org.uk> wrote:

> I'm a little uneasy about these structure definitions.  There have been
> C ABIs that set the structure alignment to at least 4 by default.  It
> may be better to play safe by declaring them '__packed'.

Yeah.  I'll add that.

David
