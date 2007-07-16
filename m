From: "Nawang Chhetan" <nawang.chhetan@gmail.com>
Subject: OCF support on 2.6 Kernel.
Date: Mon, 16 Jul 2007 15:25:12 +0530
Message-ID: <70a419b80707160255r3e4e8b1fk8c0a8ca2152d52e6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:61135 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765963AbXGPJzN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jul 2007 05:55:13 -0400
Received: by wa-out-1112.google.com with SMTP id v27so1520982wah
        for <linux-crypto@vger.kernel.org>; Mon, 16 Jul 2007 02:55:13 -0700 (PDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi All,

I am trying to integrate OCF-linux with Quicksec on linux 2.6 kernels.
Many versions of OCF-Linux have been released but wtihout clear
demarcation of 2.6 kernel versions they support. All they mention is
support for kernel verison 2.6.11 and later and the README within the
distributions states it can be easily modified to support recent
version of kernels( which is true, I did it for 2.6.17.7 )
My Question here is that:
Is there any good OCF-Linux documentation available ?

What is/are the version of 2.6 kernel, the OCF-Linux is most
stable/tested/developed for ?
Further I tried to use SafeXcel-1141 hardware accelerator ( which is
claimed to be supported) with OCF-Linux, but inserting the module
safe.ko (after ocf.ko and cryptodev.ko ) hangs the machine (Kernel
version 2.6.17.6 .).
Do I need to insmod the SafeXcel-1141 driver too ?

Please help !!

-- 
Nawang Chhetan
SafeNet India.
