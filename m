From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 4/8] akcipher: Move the RSA DER encoding to the crypto layer
Date: Tue, 23 Feb 2016 10:55:17 +0000
Message-ID: <12696.1456224917@warthog.procyon.org.uk>
References: <CAOq732LxkcSbk93ofENxL-53SFRQEtK7PcLF9LDLYmctX9W7cA@mail.gmail.com> <20160219171806.17223.91381.stgit@warthog.procyon.org.uk> <20160219171836.17223.9507.stgit@warthog.procyon.org.uk> <56CB68A2.50505@intel.com> <1562.1456180090@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Tadeusz Struk <tadeusz.struk@intel.com>,
	keyrings@vger.kernel.org, linux-security-module@vger.kernel.org,
	zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Andrew Zaborowski <balrogg@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbcBWKzU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Feb 2016 05:55:20 -0500
In-Reply-To: <CAOq732LxkcSbk93ofENxL-53SFRQEtK7PcLF9LDLYmctX9W7cA@mail.gmail.com>
Content-ID: <12695.1456224917.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andrew Zaborowski <balrogg@googlemail.com> wrote:

> AIUI Tadeusz is proposing adding the hashing as a new feature.  Note
> though that the hash paremeter won't make sense for the encrypt,
> decrypt or verify operations.

The hash parameter is necessary for the verify operation.  From my
perspective, I want a verify operation that takes the signature, the message
hash and the hash name and gives me back an error code.

David
