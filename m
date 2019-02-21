Return-Path: <SRS0=2gc/=Q4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5AEBC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 18:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8468C2084D
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Feb 2019 18:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550774527;
	bh=8WKfNcnNtJXTFf2p8f1PbAp1G/jCPpazwETOsaObbZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=TjpDstl0J1RHMQfwAXvGa4t7XnEsbHRqfJ0jOmQgIe2EOIXJL5sDHdiu8l3uFlrMt
	 p86IC4ucDVcZj0scFjKhxxt1s/iqkFxCahsGN8iwWPcDLH8lGFQWzBCwPq0lINp/iG
	 5WHKmfPvnwn0xu67NL/LZJDZ0WjHvbTxBeR8jz58=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfBUSmG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Feb 2019 13:42:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbfBUSmG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Feb 2019 13:42:06 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34FC42081B;
        Thu, 21 Feb 2019 18:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550774525;
        bh=8WKfNcnNtJXTFf2p8f1PbAp1G/jCPpazwETOsaObbZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ke37FgjPjfD4DAQE5bmCpnIW8dqvUeojVbB5fbu7JK8OR4Fz0d4bRO/cO9cW/ky01
         4dvsH301UvnSe+fJUKitDa2JRfH0Lf4vyaOmAmZHBl3WJVqhpeq3fLp/FZBf5hiPJf
         OOQnk5yz1Dh5AowMdEuYi2W4cesPUW2PoNiB9Ork=
Date:   Thu, 21 Feb 2019 10:42:03 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Richard Weinberger <richard@nod.at>
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Paul Crowley <paulcrowley@google.com>
Subject: Re: [RFC PATCH v3 07/18] fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY ioctl
Message-ID: <20190221184203.GB140206@gmail.com>
References: <20190220065249.32099-1-ebiggers@kernel.org>
 <CAFLxGvy7WsV7Qo42yTbsZf9YnW563a0k6Yx2-NmASNtoektu_Q@mail.gmail.com>
 <20190221054938.GA12467@sol.localdomain>
 <2024630.T9XyBPH5Ub@blindfold>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024630.T9XyBPH5Ub@blindfold>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 21, 2019 at 10:33:12AM +0100, Richard Weinberger wrote:
> Eric,
> 
> Am Donnerstag, 21. Februar 2019, 06:49:39 CET schrieb Eric Biggers:
> > Hi Richard,
> > 
> > On Thu, Feb 21, 2019 at 12:52:38AM +0100, Richard Weinberger wrote:
> > > On Wed, Feb 20, 2019 at 7:55 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > > +#define FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE    \
> > > > +       (CONST_STRLEN("fscrypt-") + FIELD_SIZEOF(struct super_block, s_id))
> > > > +
> > > > +#define FSCRYPT_MK_DESCRIPTION_SIZE    (2 * FSCRYPT_KEY_DESCRIPTOR_SIZE + 1)
> > > > +
> > > > +static void format_fs_keyring_description(
> > > > +                       char description[FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE],
> > > > +                       const struct super_block *sb)
> > > > +{
> > > > +       sprintf(description, "fscrypt-%s", sb->s_id);
> > > > +}
> > > 
> > > I fear ->s_id is not the right thing.
> > > For filesystems such as ext4 ->s_id is the name of the backing block device,
> > > so it is per filesysem instance unique.
> > > But this is not guaranteed. For UBIFS ->s_id is just "ubifs", always.
> > > So the names will clash.
> > > 
> > 
> > What name do you suggest using for UBIFS filesystems?  The keyring name could be
> > set by the filesystem via a fscrypt_operations callback if needed.
> 
> IMHO the BDI name should be used. 
> 
> > Note that the keyring name isn't particularly important, since the ioctls will
> > work regardless.  But we might as well choose something logical, since the
> > keyring name will still show up in /proc/keys.
> 
> I'm not done with reviewing your patches, but will it be possible to use keyctl?
> For the a unique name is helpful. :)
> 

Not for adding keys, removing keys, or getting a key's status -- those are what
the ioctls are for.

See e.g. the discussion in patch 7 ("fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY
ioctl") for why the keyrings syscalls are a poor fit for fscrypt.

- Eric
