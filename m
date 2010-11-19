From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v1.4 1/5] lib: hex2bin converts ascii hexadecimal string to binary
Date: Fri, 19 Nov 2010 15:43:03 +0000
Message-ID: <9780.1290181383@redhat.com>
References: <1290120166-3132-2-git-send-email-zohar@linux.vnet.ibm.com> <1290120166-3132-1-git-send-email-zohar@linux.vnet.ibm.com>
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
In-Reply-To: <1290120166-3132-2-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> Similar to the kgdb_hex2mem() code, hex2bin converts a string
> to binary using the hex_to_bin() library call.
> 
> Changelog:
> - Replace parameter names with src/dst (based on David Howell's comment)
> - Add 'const' where needed (based on David Howell's comment)
> - Replace int with size_t (based on David Howell's comment)
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Acked-by: Serge E. Hallyn <serge@hallyn.com>

Acked-by: David Howells <dhowells@redhat.com>
