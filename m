From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v1.3 4/4] keys: add new key-type encrypted
Date: Tue, 16 Nov 2010 18:58:18 +0000
Message-ID: <27397.1289933898@redhat.com>
References: <1289933690.2627.19.camel@localhost.localdomain> <1289918320.3188.16.camel@localhost.localdomain> <1289849751.3027.17.camel@localhost.localdomain> <1289694826.3257.82.camel@localhost.localdomain> <1289595738.2731.80.camel@localhost.localdomain> <1289404309-15955-5-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com> <26689.1289591135@redhat.com> <27900.1289597013@redhat.com> <8268.1289837934@redhat.com> <23151.1289916524@redhat.com> <26645.1289929851@redhat.com>
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
In-Reply-To: <1289933690.2627.19.camel@localhost.localdomain>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> No, this just updates the name of the key used to encrypt/decrypt the
> encrypted key. For example, the encrypted key evm-key is initially
> encrypted/decrypted using 'kmk-trusted'.  After the update, it is
> encrypted/decrypted with 'kmk'.  Both now are trusted keys.

Gotcha.  The problem is that there are two many different objects in the
system called 'keys':-)

David
