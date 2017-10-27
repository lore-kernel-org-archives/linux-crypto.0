From: Stephen Brennan <stephen@brennan.io>
Subject: Re: [PATCH] staging: ccree: Fix indentation in ssi_buffer_mgr.c
Date: Fri, 27 Oct 2017 07:42:01 -0700
Message-ID: <20171027144201.GA11920@pride.cult>
References: <20171027015342.6345-1-stephen@brennan.io>
 <20171027083247.sdsdwjiyhyflvjug@mwanda>
 <1509114238.1914.4.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1509114238.1914.4.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 27, 2017 at 07:23:58AM -0700, Joe Perches wrote:
> On Fri, 2017-10-27 at 11:32 +0300, Dan Carpenter wrote:
> > But then ssi_buffer_mgr_copy_scatterlist_portion() is still not indented
> > correctly.

Yeah, I don't know how I missed it. I'll send a new version of the patch
out momentarily.

> The latest version of checkpatch should bleat something on the
> 	...scatterlist_portion(
> line

Strangely, my checkpatch doesn't complain about it, but I guess you can't
always rely on tools for this stuff. For reference, I'm currently on the
10/18 linux-next branch.
