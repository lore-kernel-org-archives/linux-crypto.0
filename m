From: Stafford Horne <shorne@gmail.com>
Subject: Re: [PATCH v2 2/2] kobject: Fix -Wstringop-truncation warning
Date: Mon, 25 Jun 2018 22:24:45 +0900
Message-ID: <20180625132445.GI24595@lianli.shorne-pla.net>
References: <20180625124538.21051-1-shorne@gmail.com>
 <20180625124538.21051-3-shorne@gmail.com>
 <c89dd856-3637-b235-f134-e15621eab2c6@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org
To: Christophe LEROY <christophe.leroy@c-s.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c89dd856-3637-b235-f134-e15621eab2c6@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 25, 2018 at 02:57:13PM +0200, Christophe LEROY wrote:
> 
> 
> Le 25/06/2018 à 14:45, Stafford Horne a écrit :
> > When compiling with GCC 9.0.0 I am seeing the following warning:
> > 
> >      In function ‘fill_kobj_path’,
> > 	inlined from ‘kobject_get_path’ at lib/kobject.c:155:2:
> >      lib/kobject.c:128:3: warning: ‘strncpy’ output truncated before terminating nul copying as many bytes from a string as its length [-Wstringop-truncation]
> >         strncpy(path + length, kobject_name(parent), cur);
> >         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >      lib/kobject.c: In function ‘kobject_get_path’:
> >      lib/kobject.c:125:13: note: length computed here
> >         int cur = strlen(kobject_name(parent));
> > 		 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > This is not really an issue since the buffer we are writing to is
> > pre-zero'd and we have already allocated the buffer based on the
> > calculated strlen size and accounted for the terminating '\0'.
> > Just use memcpy() instead.
> 
> If we are already sure the destination is big enough, why not just do a
> strcpy() and drop the 'cur = strlen()' ?

Hi Christophe,

Here were are writing multiple strings into a buffer from back to front.  We are
copying exactly strlen() bytes at a time to avoid the nul terminator being
copied into the buffer.

I don't doubt we could use strcpy() but I was trying to keep the change small.

-Stafford

> > 
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Eric Biggers <ebiggers3@gmail.com>
> > Signed-off-by: Stafford Horne <shorne@gmail.com>
> > ---
> >   lib/kobject.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/lib/kobject.c b/lib/kobject.c
> > index 18989b5b3b56..e876957743c8 100644
> > --- a/lib/kobject.c
> > +++ b/lib/kobject.c
> > @@ -125,7 +125,7 @@ static void fill_kobj_path(struct kobject *kobj, char *path, int length)
> >   		int cur = strlen(kobject_name(parent));
> >   		/* back up enough to print this name with '/' */
> >   		length -= cur;
> > -		strncpy(path + length, kobject_name(parent), cur);
> > +		memcpy(path + length, kobject_name(parent), cur);
> >   		*(path + --length) = '/';
> >   	}
> > 
