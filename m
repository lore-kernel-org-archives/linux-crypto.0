From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH 2/2] kobject: Fix -Wstringop-truncation warning
Date: Fri, 22 Jun 2018 19:31:49 -0700
Message-ID: <20180623023149.GA880@sol.localdomain>
References: <20180623020753.27266-1-shorne@gmail.com>
 <20180623020753.27266-3-shorne@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de,
        linux-crypto@vger.kernel.org
To: Stafford Horne <shorne@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180623020753.27266-3-shorne@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jun 23, 2018 at 11:07:53AM +0900, Stafford Horne wrote:
> When compiling with GCC 9.0.0 I am seeing the following warning:
> 
>     In function ‘fill_kobj_path’,
> 	inlined from ‘kobject_get_path’ at lib/kobject.c:155:2:
>     lib/kobject.c:128:3: warning: ‘strncpy’ output truncated before terminating nul copying as many bytes from a string as its length [-Wstringop-truncation]
>        strncpy(path + length, kobject_name(parent), cur);
>        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     lib/kobject.c: In function ‘kobject_get_path’:
>     lib/kobject.c:125:13: note: length computed here
>        int cur = strlen(kobject_name(parent));
> 		 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This is pointing out a bug that the strncpy limit is the source string not the
> destination buffer remaining length.  Fix it.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Stafford Horne <shorne@gmail.com>
> ---
>  lib/kobject.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 18989b5b3b56..15338e5a96f2 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -125,7 +125,7 @@ static void fill_kobj_path(struct kobject *kobj, char *path, int length)
>  		int cur = strlen(kobject_name(parent));
>  		/* back up enough to print this name with '/' */
>  		length -= cur;
> -		strncpy(path + length, kobject_name(parent), cur);
> +		strncpy(path + length, kobject_name(parent), length);
>  		*(path + --length) = '/';
>  	}

It should be replaced with memcpy(), AFAICS; it wouldn't change the behavior but
it would quiet the gcc warning.  Your proposed "fix" is heavily broken: notice
that the code is building a string backwards (end to beginning).

- Eric
