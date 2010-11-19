From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v1.4 3/5] key: add tpm_send command
Date: Fri, 19 Nov 2010 15:45:37 +0000
Message-ID: <9837.1290181537@redhat.com>
References: <1290120166-3132-4-git-send-email-zohar@linux.vnet.ibm.com> <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	James Morris <jmorris@namei.org>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Mimi Zohar <zohar@watson.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab0KSPps (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Nov 2010 10:45:48 -0500
In-Reply-To: <1290120166-3132-4-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> +int tpm_send(u32 chip_num, void *cmd, int buflen)

I'd recommend size_t for buflen; apart from that:

Acked-by: David Howells <dhowells@redhat.com>
