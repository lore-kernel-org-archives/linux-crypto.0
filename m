From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 4/4] staging: most: Remove a attribute
 group from a kobject
Date: Tue, 28 Nov 2017 14:21:48 +0100
Message-ID: <20171128132148.GA29890@kroah.com>
References: <1511591971-8615-1-git-send-email-arvind.yadav.cs@gmail.com>
 <1511591971-8615-5-git-send-email-arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, driverdev-devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org,
 linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org,
 vitaly_fertman-qCPWdT176rRBDgjK7y7TUQ@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, lustre-devel-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org
To: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <lustre-devel-bounces-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1511591971-8615-5-git-send-email-arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://lists.lustre.org/options.cgi/lustre-devel-lustre.org>,
 <mailto:lustre-devel-request-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.lustre.org/pipermail/lustre-devel-lustre.org/>
List-Post: <mailto:lustre-devel-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org>
List-Help: <mailto:lustre-devel-request-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org?subject=help>
List-Subscribe: <http://lists.lustre.org/listinfo.cgi/lustre-devel-lustre.org>,
 <mailto:lustre-devel-request-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org?subject=subscribe>
Errors-To: lustre-devel-bounces-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org
Sender: "lustre-devel" <lustre-devel-bounces-aLEFhgZF4x6X6Mz3xDxJMA@public.gmane.org>
List-Id: linux-crypto.vger.kernel.org

On Sat, Nov 25, 2017 at 12:09:31PM +0530, Arvind Yadav wrote:
> All attribute group created during dim2_sysfs_probe() should be removed
> in dim2_sysfs_destroy().
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/staging/most/hdm-dim2/dim2_sysfs.c | 1 +

This file is not in the tree anymore.
