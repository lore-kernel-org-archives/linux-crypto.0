From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] KEYS: Add placeholder for KDF usage with DH
Date: Tue, 31 May 2016 10:37:19 +0100
Message-ID: <26983.1464687439@warthog.procyon.org.uk>
References: <9470.1464302447@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org
To: jmorris@namei.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <9470.1464302447@warthog.procyon.org.uk>
Content-ID: <26982.1464687439.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi James,

> Could you pass this along to Linus as soon as possible, please?  This
> alters a new keyctl function added in the current merge window to allow for
> a future extension planned for the next merge window.

Is this likely to go to Linus before -rc2?  If not, we'll need to do things
differently.

David
