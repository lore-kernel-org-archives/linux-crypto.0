From: Christoph Hellwig <hch@lst.de>
Subject: Re: export pcie_flr and remove copies of it in drivers
Date: Fri, 14 Apr 2017 17:57:29 +0200
Message-ID: <20170414155729.GC22412@lst.de>
References: <20170413145339.20186-1-hch@lst.de> <20170414144108.GB29349@bhelgaas-glaptop.roam.corp.google.com> <CAErSpo4HBhG5cLZMMt4NtswjQ1yNvW9x39DsxFWtBPOVwG7JpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Derek Chickles <derek.chickles@caviumnetworks.com>,
        Satanand Burla <satananda.burla@caviumnetworks.com>,
        Felix Manlunas <felix.manlunas@caviumnetworks.com>,
        Raghu Vatsavayi <raghu.vatsavayi@caviumnetworks.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43494 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752152AbdDNP5b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Apr 2017 11:57:31 -0400
Content-Disposition: inline
In-Reply-To: <CAErSpo4HBhG5cLZMMt4NtswjQ1yNvW9x39DsxFWtBPOVwG7JpA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 14, 2017 at 09:51:48AM -0500, Bjorn Helgaas wrote:
> > Otherwise, I'd be glad to take the series given acks for the non-PCI
> > parts.  Just let me know.
> 
> I do already have a patch (c5e4f0192ad2 ("PCI: Avoid FLR for Intel
> 82579 NICs")) on my pci/virtualization branch that touches pcie_flr()
> and will conflict with this one.

I'll take a look and will resend on top of that branch.
