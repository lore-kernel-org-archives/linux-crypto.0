From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v1.5 0/5] keys: trusted and encrypted keys
Date: Mon, 29 Nov 2010 08:56:34 +1100 (EST)
Message-ID: <alpine.LRH.2.00.1011290856070.15604@tundra.namei.org>
References: <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 23 Nov 2010, Mimi Zohar wrote:

> Mimi Zohar (5):
>   lib: hex2bin converts ascii hexadecimal string to binary
>   tpm: add module_put wrapper
>   key: add tpm_send command
>   keys: add new trusted key-type
>   keys: add new key-type encrypted

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
