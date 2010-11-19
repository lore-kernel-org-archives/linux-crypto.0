From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v1.4 3/5] key: add tpm_send command
Date: Fri, 19 Nov 2010 16:45:44 +0000
Message-ID: <10612.1290185144@redhat.com>
References: <1290182696.2597.18.camel@localhost.localdomain> <1290120166-3132-4-git-send-email-zohar@linux.vnet.ibm.com> <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com> <9837.1290181537@redhat.com>
Cc: dhowells@redhat.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	James Morris <jmorris@namei.org>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Mimi Zohar <zohar@watson.ibm.com>
To: David Safford <safford@watson.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1290182696.2597.18.camel@localhost.localdomain>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

David Safford <safford@watson.ibm.com> wrote:

> Currently transmit_command() in tpm.c expects an int,
> but it changes it to size_t for the actual tpm_transmit().
> We will work with Rajiv to do a cleanup, as this touches
> a number of calls.

You can pass a size_t value to an int.  The compiler will cast automatically.

David
