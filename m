From: Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 02/16] MPILIB: Add a missing ENOMEM check [ver #2]
Date: Wed, 30 Nov 2011 09:28:11 -0600
Message-ID: <4ED64B8B.1050806@canonical.com>
References: <20111129234258.13625.21153.stgit@warthog.procyon.org.uk> <20111129234323.13625.34554.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
	zohar@linux.vnet.ibm.com, arjan.van.de.ven@intel.com,
	alan.cox@intel.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51784 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab1K3P2T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Nov 2011 10:28:19 -0500
In-Reply-To: <20111129234323.13625.34554.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/29/2011 05:43 PM, David Howells wrote:
> Add a missing ENOMEM check.
>
> Signed-off-by: David Howells<dhowells@redhat.com>
> ---
>
>   lib/mpi/mpicoder.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
>
> diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
> index fe84bb9..6e225a8 100644
> --- a/lib/mpi/mpicoder.c
> +++ b/lib/mpi/mpicoder.c
> @@ -255,6 +255,8 @@ void *mpi_get_buffer(MPI a, unsigned *nbytes, int *sign)
>   	if (!n)
>   		n++;		/* avoid zero length allocation */
>   	p = buffer = kmalloc(n, GFP_KERNEL);
> +	if (p<  0)
> +		return NULL;

Sorry, maybe i'm having a confused morning, but shouldn't this check be 
for p==NULL rather than p<0?

>
>   	for (i = a->nlimbs - 1; i>= 0; i--) {
>   		alimb = a->d[i];
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
