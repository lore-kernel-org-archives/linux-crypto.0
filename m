From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/4] lib: hex2bin converts ascii hexadecimal
 string to binary
Date: Wed, 29 Sep 2010 09:51:38 -0400
Message-ID: <1285768298.3213.50.camel@localhost.localdomain>
References: <1285698993-16927-2-git-send-email-zohar@linux.vnet.ibm.com>
	 <1285698993-16927-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <9444.1285762263@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Mimi Zohar <zohar@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <9444.1285762263@redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2010-09-29 at 13:11 +0100, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > --- a/lib/hexdump.c
> > +++ b/lib/hexdump.c
> > @@ -34,6 +34,22 @@ int hex_to_bin(char ch)
> >  EXPORT_SYMBOL(hex_to_bin);
> >  
> >  /**
> > + * hex2bin - convert an ascii hexadecimal string to its binary representation
> > + * @mem: result
> > + * @buf: ascii hexadecimal string
> > + * @count: result length
> > + */
> > +void hex2bin(unsigned char *mem, char *buf, int count)
> 
> Hmmm...  It might be better to put this in its own file in lib, otherwise it
> will drag in all the other functions in that file if used, and vice versa.
> 
> David

hex2bin calls hex_to_bin() which is defined right above it in the same
file. But the reverse, as you suggested, is still true.

thanks,

Mimi

