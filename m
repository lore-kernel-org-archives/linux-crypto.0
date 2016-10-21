From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: sg_set_buf
Date: Fri, 21 Oct 2016 05:26:14 -0700
Message-ID: <20161021122614.GA28059@infradead.org>
References: <20161018213755.GA10777@fieldses.org>
 <20161020102200.GA6628@infradead.org>
 <20161020132030.GA2868@fieldses.org>
 <20161020133107.GA11993@infradead.org>
 <20161020214219.GC4347@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
        linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161020214219.GC4347-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 20, 2016 at 05:42:19PM -0400, J. Bruce Fields wrote:
> Turns out there are several places in the kerberos code where it just
> needs to encrypt one small checksum or sequence number, and it's been
> doing that on the stack.
> 
> For now I'll just sprinkle kmalloc()'s all over.  Eventually we'll need
> to find something better.

I agree that it would be nice to be able to hash small objects on the
stack.  But unless I've missed something there is no way to do that
without using struct scatterlist.  I've added linux-crypto to the cc
list to confirm that I really didn't miss anything.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
