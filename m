From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v1.3 1/4] lib: hex2bin converts ascii hexadecimal string to binary
Date: Thu, 11 Nov 2010 19:48:47 +0000
Message-ID: <6640.1289504927@redhat.com>
References: <1289404309-15955-2-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
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
In-Reply-To: <1289404309-15955-2-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> +void hex2bin(unsigned char *mem, char *buf, int count)

I think this needs a little adjustment.  I would recommend something like the
following declaration:

	void hex2bin(u8 *buf, const char *data, size_t count)

since the output data is binary (so use u8*), you're only reading the source
data (so should use a const pointer) and you don't want to see a negative
count (so use size_t).

Also, I'd suggest calling the source arg 'data' and the output arg 'buf' or
maybe src/dst.

David
