From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] KEYS: Load *.x509 files into kernel keyring
Date: Thu, 17 Jan 2013 13:44:23 -0500
Message-ID: <1358448263.2689.75.camel@falcor1>
References: <20130117180352.27885.79893.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: dmitry.kasatkin@intel.com, linux-kernel@vger.kernel.org,
	keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60900 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab3AQSoh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jan 2013 13:44:37 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Thu, 17 Jan 2013 13:44:36 -0500
In-Reply-To: <20130117180352.27885.79893.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2013-01-17 at 18:03 +0000, David Howells wrote:
> Load all the files matching the pattern "*.x509" that are to be found in kernel
> base source dir and base build dir into the module signing keyring.

Do we really want certificates cluttering up the base source tree? Any
reason not to define an x509 directory?

> The "extra_certificates" file is then redundant.

Ok.

Mimi
