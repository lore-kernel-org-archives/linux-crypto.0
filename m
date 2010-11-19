From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v1.4 2/5] tpm: add module_put wrapper
Date: Fri, 19 Nov 2010 15:43:46 +0000
Message-ID: <9797.1290181426@redhat.com>
References: <1290120166-3132-3-git-send-email-zohar@linux.vnet.ibm.com> <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	James Morris <jmorris@namei.org>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Mimi Zohar <zohar@us.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1290120166-3132-3-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> For readability, define a tpm_chip_put() wrapper to call module_put().
> Replace existing module_put() calls with the wrapper.
> 
> (Change based on trusted/encrypted patchset review by David Howells.)
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Signed-off-by: David Safford <safford@watson.ibm.com>

Acked-by: David Howells <dhowells@redhat.com>
