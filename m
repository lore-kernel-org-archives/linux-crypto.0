From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] KEYS: Add a 'trusted' flag and a 'trusted only' flag
Date: Wed, 30 Jan 2013 10:32:56 +0000
Message-ID: <14690.1359541976@warthog.procyon.org.uk>
References: <CALLzPKayx83x6KRs9NSjthR1H4VR1PzEcYhnGJU6gnrWMs7_fg@mail.gmail.com> <20130117180352.27885.79893.stgit@warthog.procyon.org.uk> <20130117180407.27885.54342.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, zohar@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org, keyrings@linux-nfs.org,
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab3A3KdD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Jan 2013 05:33:03 -0500
In-Reply-To: <CALLzPKayx83x6KRs9NSjthR1H4VR1PzEcYhnGJU6gnrWMs7_fg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:

> What about the case when running from integrity protected initramfs?
> Either embedded into the signed kernel, or verified by the boot loader.
> In such case it is possible to assume that all keys which are added by
> user space are implicitly trusted.
> Later on, before continuing booting normal rootfs, set the key
> subsystem state (trust-lock),
> so that trusted keyrings accept only explicitly trusted keys...
> 
> Does it make sense?

I'm not sure it does.  Initramfs is (re-)fabricated on the machine on which it
runs any time you update one of a set of rpms (such as the kernel rpm) because
it has machine-specific data and drivers in it.

David
