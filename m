From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] Don't require SpcSpOpusInfo in Authenticode pkcs7
 signatures
Date: Tue, 19 Jan 2016 09:08:44 +0800
Message-ID: <20160119010844.GA2919@dhcp-128-65.nay.redhat.com>
References: <20160115081249.GA19487@dhcp-128-65.nay.redhat.com>
 <1453132198-19644-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Howells <dhowells@redhat.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	xlpang@redhat.com, vgoyal@redhat.com
To: Peter Jones <pjones@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932530AbcASBI6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2016 20:08:58 -0500
Content-Disposition: inline
In-Reply-To: <1453132198-19644-1-git-send-email-pjones@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/18/16 at 10:49am, Peter Jones wrote:
> Dave Young reported:
> > Hi,
> >
> > I saw the warning "Missing required AuthAttr" when testing kexec,
> > known issue?  Idea about how to fix it?
> >
> > The kernel is latest linus tree plus sevral patches from Toshi to
> > cleanup io resource structure.
> >
> > in function pkcs7_sig_note_set_of_authattrs():
> >         if (!test_bit(sinfo_has_content_type, &sinfo->aa_set) ||
> >             !test_bit(sinfo_has_message_digest, &sinfo->aa_set) ||
> >             (ctx->msg->data_type == OID_msIndirectData &&
> >              !test_bit(sinfo_has_ms_opus_info, &sinfo->aa_set))) {
> >                 pr_warn("Missing required AuthAttr\n");
> >                 return -EBADMSG;
> >         }
> >
> > The third condition below is true:
> > (ctx->msg->data_type == OID_msIndirectData &&
> >              !test_bit(sinfo_has_ms_opus_info, &sinfo->aa_set))
> >
> > I signed the kernel with redhat test key like below:
> > pesign -c 'Red Hat Test Certificate' -i arch/x86/boot/bzImage -o /boot/vmlinuz-4.4.0-rc8+ -s --force
> 
> And right he is!  The Authenticode specification is a paragon amongst
> technical documents, and has this pearl of wisdom to offer:
> 
> ---------------------------------
> Authenticode-Specific SignerInfo UnauthenticatedAttributes Structures
> 
>   The following Authenticode-specific data structures are present in
>   SignerInfo authenticated attributes.
> 
>   SpcSpOpusInfo
>   SpcSpOpusInfo is identified by SPC_SP_OPUS_INFO_OBJID
>   (1.3.6.1.4.1.311.2.1.12) and is defined as follows:
>   SpcSpOpusInfo ::= SEQUENCE {
>     programName  [0] EXPLICIT SpcString OPTIONAL,
>     moreInfo     [1] EXPLICIT SpcLink OPTIONAL,
>   } --#public--
> 
>   SpcSpOpusInfo has two fields:
>     programName
>       This field contains the program description:
>       If publisher chooses not to specify a description, the SpcString
>       structure contains a zero-length program name.
>       If the publisher chooses to specify a
>       description, the SpcString structure contains a Unicode string.
>     moreInfo
>       This field is set to an SPCLink structure that contains a URL for
>       a Web site with more information about the signer. The URL is an
>       ASCII string.
> ---------------------------------
> 
> Which is to say that this is an optional *unauthenticated* field which
> may be present in the Authenticated Attribute list.  This is not how
> pkcs7 is supposed to work, so when David implemented this, he didn't
> appreciate the subtlety the original spec author was working with, and
> missed the part of the sublime prose that says this Authenticated
> Attribute is an Unauthenticated Attribute.  As a result, the code in
> question simply takes as given that the Authenticated Attributes should
> be authenticated.
> 
> But this one should not, individually.  Because it says it's not
> authenticated.
> 
> It still has to hash right so the TBS digest is correct.  So it is both
> authenticated and unauthenticated, all at once.  Truly, a wonder of
> technical accomplishment.
> 
> Additionally, pesign's implementation has always attempted to be
> compatible with the signatures emitted from contemporary versions of
> Microsoft's signtool.exe.  During the initial implementation, Microsoft
> signatures always produced the same values for SpcSpOpusInfo -
> {U"Microsoft Windows", "http://www.microsoft.com"} - without regard to
> who the signer was.
> 
> Sometime between Windows 8 and Windows 8.1 they stopped including the
> field in their signatures altogether, and as such pesign stopped
> producing them in commits c0c4da6 and d79cb0c, sometime around June of
> 2012.  The theory here is that anything that breaks with
> pesign signatures would also be breaking with signtool.exe sigs as well,
> and that'll be a more noticed problem for firmwares parsing it, so it'll
> get fixed.  The fact that we've done exactly this bug in Linux code is
> first class, grade A irony.
> 
> So anyway, we should not be checking this field for presence or any
> particular value: if the field exists, it should be at the right place,
> but aside from that, as long as the hash matches the field is good.
> 
> Signed-off-by: Peter Jones <pjones@redhat.com>
> ---
>  crypto/asymmetric_keys/pkcs7_parser.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
> index 758acab..8f3056c 100644
> --- a/crypto/asymmetric_keys/pkcs7_parser.c
> +++ b/crypto/asymmetric_keys/pkcs7_parser.c
> @@ -547,9 +547,7 @@ int pkcs7_sig_note_set_of_authattrs(void *context, size_t hdrlen,
>  	struct pkcs7_signed_info *sinfo = ctx->sinfo;
>  
>  	if (!test_bit(sinfo_has_content_type, &sinfo->aa_set) ||
> -	    !test_bit(sinfo_has_message_digest, &sinfo->aa_set) ||
> -	    (ctx->msg->data_type == OID_msIndirectData &&
> -	     !test_bit(sinfo_has_ms_opus_info, &sinfo->aa_set))) {
> +	    !test_bit(sinfo_has_message_digest, &sinfo->aa_set)) {
>  		pr_warn("Missing required AuthAttr\n");
>  		return -EBADMSG;
>  	}
> -- 
> 2.5.0
> 

Tested-by: Dave Young <dyoung@redhat.com>

Peter, thanks for the expanation. I was using such fix for several days but 
not sure if it is right or not though it works for me.

Dave
