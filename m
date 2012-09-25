From: David Howells <dhowells@redhat.com>
Subject: Wrong system clock vs X.509 date specifiers
Date: Tue, 25 Sep 2012 16:09:54 +0100
Message-ID: <21845.1348585794@warthog.procyon.org.uk>
References: <5555.1348531649@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au,
	pjones@redhat.com, jwboyer@redhat.com,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
To: rusty@rustcorp.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893Ab2IYPKF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Sep 2012 11:10:05 -0400
In-Reply-To: <5555.1348531649@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


The X.509 certificate has a pair of times in it that delineate the valid
period of the cert, and I'm checking that the system clock is within the
bounds they define before permitting you to use the cert.  I've been setting
the expiry date to be 100 years in the future - by which time hopefully I
won't have to worry about it - but occasionally clock skew means a freshly
built kernel won't boot because the machine trying to boot doesn't think that
the start time has been reached yet.

Do we actually want to do this, however?  Or should we just ignore the times?
Or just the start time?

Unfortunately, the ASN.1 says the field are mandatory, and openssl doesn't
seem to give you a way to backdate the start time.

David
