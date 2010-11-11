From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v1.3 2/4] key: add tpm_send command
Date: Thu, 11 Nov 2010 17:25:56 -0500
Message-ID: <1289514356.2726.18.camel@localhost.localdomain>
References: <1289404309-15955-3-git-send-email-zohar@linux.vnet.ibm.com>
	 <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <6651.1289504931@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	James Morris <jmorris@namei.org>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <6651.1289504931@redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 2010-11-11 at 19:48 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > Reviewd-by: Mimi Zohar <zohar@watson.ibm.com>
> 
> You've missed an 'e'.

thanks, will fix

> > +int tpm_send(u32 chip_num, char *cmd, int buflen)
> > +{
> > ...
> > +	rc = transmit_cmd(chip, (struct tpm_cmd_t *)cmd, buflen,
> > +			  "attempting tpm_cmd");
> 
> Make cmd 'void *' to obviate the cast.  Preferably it should be const too.

will do

> > +	module_put(chip->dev->driver->owner);
> 
> Where's the corresponding module_get()?  I suspect this should be wrapped to
> match tpm_chip_find_get().
> 
> David

The module_get() is in tpm_chip_find_get(), which is just a helper.
(It's used this way throughout tpm.c)

thanks,

Mimi

