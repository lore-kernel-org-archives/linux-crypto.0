From: David Safford <safford@watson.ibm.com>
Subject: Re: [PATCH v1.5 3/5] key: add tpm_send command
Date: Wed, 24 Nov 2010 11:31:23 -0500
Message-ID: <1290616283.2785.36.camel@localhost.localdomain>
References: <1290552635-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1290556456.2604.14.camel@localhost.localdomain>
	 <20101124023238.GA26540@tiny>
	 <1290602771.2785.14.camel@localhost.localdomain>
	 <20101124145925.GA2203@tiny>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	James Morris <jmorris@namei.org>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20101124145925.GA2203@tiny>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2010-11-24 at 08:59 -0600, Serge Hallyn wrote:
> Quoting David Safford (safford@watson.ibm.com):
> > On Tue, 2010-11-23 at 20:32 -0600, Serge Hallyn wrote:
> > > Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> > > > Add internal kernel tpm_send() command used to seal/unseal keys.
> > ... 
> > > > +int tpm_send(u32 chip_num, void *cmd, size_t buflen)
> > > 
> > > Hate to nit-pick, but any particular reason you're not following the
> > > rest of the file and using 'struct tpm_cmd_t *cmd' here?
> > > 
> > > Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> > 
> > We put some thought into this one. TPM command packets are
> > binary blobs with lots of optional and variable length fields,
> > and there are at least three common approaches to creating them:
> > structures (as used in tpm.c), load/store (as used in trousers
> > and trusted-keys), and an sprintf like format string (as used
> > in the original libtpm.) Each has its advantages and disadvantages.
> > Structures are nice for the simple TPM commands, but they become
> > unwieldy for the complex commands like seal and unseal. Load/store
> > is much more readable for the complex seal and unseal commands.
> > Format strings are nice for creating the most complex commands
> > in the fewest lines of code, but are way overkill for simple ones.
> > 
> > With the void *cmd, we are allowing the other modules to pick
> > whichever method most suits their needs.
> 
> Jinkeys, that's complicated :)
> 
> But doesn't that mean that the transmit_cmd() parameters are lying?
> Should the second argument for transmit_cmd() be a union?
> 
> (If only to help out the lamentable reader)
> 
> thanks,
> -serge
ah.
transmit_cmd() takes a struct tpm_cmd_t * and immediately casts
it to u8 * for tpm_transmit(). So sending in a u8 * isn't
so much lying as recognizing that tpm_cmd_t * and u8 * are
equivalent :-) 
I suppose a union would be more correct, although I'm not
sure it would be easier for the lamentable reader...

dave


